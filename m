Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbXGXHSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbXGXHSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXGXHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:18:29 -0400
Received: from main.gmane.org ([80.91.229.2]:60669 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbXGXHS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:18:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Linux TCP modifications
Date: Tue, 24 Jul 2007 08:18:18 +0100
Organization: Linux Foundation
Message-ID: <20070724081818.57d5b0d1@oldman>
References: <20070724160139.M84420@universe.cdotb.ernet.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87.192.216.40
In-Reply-To: <20070724160139.M84420@universe.cdotb.ernet.in>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 12:11:39 -0400
"Pallab Dutta" <pallab@cdotb.ernet.in> wrote:

> Hi,
> 
> I want to change the TCP ( for a given specific application with lots of
> modifications to the basic TCP) implementation in Linux and integrate it with
> the linux kernal. Since TCP comes as apart of Linux kernal and also TCP and IP
> implementations in Linux are tightly coupled, please suggest how to go about
> integrating TCP (which is developed for a specific application with lots of
> modifications) into Linux kernal. Kindly give as much details as possible.  
> 
> regards,
> Pallab.

Post the source code for your modifications so others can review
on the proper list: netdev@vger.kernel.org

The modifications may be useful for other applications.

