Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYKDP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYKDP0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYKDP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:26:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37393 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753158AbYKDP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:26:31 -0500
Date: Tue, 4 Nov 2008 15:24:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Albert Comerma <albert@ecm.ub.es>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Somebody will apply it?
Message-ID: <20081104152434.4be96db8@lxorguk.ukuu.org.uk>
In-Reply-To: <49106865.1080009@ecm.ub.es>
References: <49106865.1080009@ecm.ub.es>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 16:21:09 +0100
Albert Comerma <albert@ecm.ub.es> wrote:

> Since my previous message seems did not arrive anyone interested I 
> repeat it, stressing that the maintainer seems not to maintain the 
> driver, so somebody with access should apply the patch. It's a trivial 
> patch...

Needs a Signed-off-by: line, but otherwise yes looks trivial if you've
tested the driver with the new USB id


Alan
