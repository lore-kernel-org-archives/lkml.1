Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZLIMBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZLIMBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 07:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZLIMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 07:01:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40470 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752876AbZLIMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 07:01:30 -0500
Date: Wed, 9 Dec 2009 12:03:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] firmware/WHENCE: Correct filenames for ambassador,
 bnx2x, cxgb3
Message-ID: <20091209120334.4b7f2051@lxorguk.ukuu.org.uk>
In-Reply-To: <1260335742.4532.246.camel@localhost>
References: <1260335742.4532.246.camel@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Dec 2009 05:15:42 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> Filenames should be the names of the installed binary files, without
> the base directory.

Disagree - the WHENCE file says where it comes from and if it originally
came in a hex file then thats the origin.

