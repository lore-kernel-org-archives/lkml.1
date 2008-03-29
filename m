Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYC2RKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYC2RKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYC2RJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:09:56 -0400
Received: from main.gmane.org ([80.91.229.2]:43025 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYC2RJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:09:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
Date: Sat, 29 Mar 2008 17:09:46 +0000 (UTC)
Message-ID: <loom.20080329T170802-485@post.gmane.org>
References: <610674.43534.qm@web46002.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.60.34.230 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9pre) Gecko/2008032904 Mozilla/5.01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Sousa <ls.luis_sousa <at> yahoo.com.br> writes:

> 
> Oops. My bad. I seem to actually be running the "nv" driver in xorg.conf. 
> I had searched for "nvidia" before and so thought I had cleared that.
> I didn't recall manually installing it this time. I'll try not using it.

The "nv" driver is open source and it does not load any proprietary kernel
module - so no need to avoid using that. It comes with Xorg and is loaded
automatically if you have nvidia card.

Parag



