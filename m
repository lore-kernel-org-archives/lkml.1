Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYDQAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYDQAyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYDQAyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:54:31 -0400
Received: from mail.tuxonice.net ([67.207.135.122]:54149 "EHLO
	mail.tuxonice.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYDQAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:54:30 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: RFC: Self-snapshotting in Linux
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org
In-Reply-To: <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com>
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it>
	 <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 10:55:23 +1000
Message-Id: <1208393723.6206.1.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2008-04-16 at 03:27 -0700, Alan Jenkins wrote:
> I guess there is the hardware / drivers issue.  I would like to claim
> I've found hibernation to be reliable but unfortunately that's not
> 100% true.  As you say, that's inherent to snapshotting on
> unvirtualised hardware - calling it snapshotting instead of
> hibernation wouldn't change anything.

On a particular set of hardware, it should be possible to make it 100%
reliable. If you've found bugs, please report them. We can only fix
issues if we know they exist.

Regards,

Nigel

