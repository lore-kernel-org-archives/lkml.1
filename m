Return-Path: <linux-kernel-owner+w=401wt.eu-S1422949AbXBATKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422949AbXBATKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXBATK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:10:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422945AbXBATK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:10:28 -0500
Date: Thu, 1 Feb 2007 11:07:06 -0800
From: Stephen Hemminger <shemminger@osdl.org>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: LKML <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070201110706.74d2c059@localhost>
In-Reply-To: <20070201185532.GL13130@cip.informatik.uni-erlangen.de>
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de>
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; i486-pc-linux-gnu)
X-Face: &@E+xe?c%:&e4D{>f1O<&U>2qwRREG5!}7R4;D<"NO^UI2mJ[eEOA2*3>(`Th.yP,VDPo9$
 /`~cw![cmj~~jWe?AHY7D1S+\}5brN0k*NE?pPh_'_d>6;XGG[\KDRViCfumZT3@[
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 19:55:32 +0100
Thomas Glanzmann <thomas@glanzmann.de> wrote:

> Hello,
> I have a sky2 network card in my intel mac mini. It stops working when I
> do havy network load like watching a divx over http/sshfs.

Is this heavy Tx load (ie your watching movie from mac mini). or Rx load
(you are watching movie on mac mini).
