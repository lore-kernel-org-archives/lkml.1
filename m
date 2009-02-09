Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZBIKeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZBIKeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZBIKde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:33:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:59494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZBIKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:33:32 -0500
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Peter Zijlstra <peterz@infradead.org>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
In-Reply-To: <1234135463.12370.47.camel@champagne.cantina>
References: <1234011974.7435.11.camel@champagne.cantina>
	 <20090208221625.GB8830@disturbed>
	 <1234135463.12370.47.camel@champagne.cantina>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 11:33:27 +0100
Message-Id: <1234175607.5951.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 00:24 +0100, Alessandro Bono wrote:
> In the past I lose configuration files from kde, gconf based programs
> (gnome), pan, firefox, etc
> maybe xfs expose more this problem  

>From what I heard Linux userspace is on crack and thinks it can get away
without calling fsync().



