Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYEKF4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYEKF4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 01:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYEKF42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 01:56:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45014 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYEKF42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 01:56:28 -0400
Date: Sat, 10 May 2008 23:57:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: HDIO_DRIVE_CMD failed on Dell Latitude D630
In-reply-to: <fa.JGa9Aoo1QI9XNBPx1yZ0T7IP4qY@ifi.uio.no>
To: Marcelo Laia <marcelolaia@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <48268ABC.9000700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.JGa9Aoo1QI9XNBPx1yZ0T7IP4qY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Laia wrote:
> Dear Kernel Developer,
> 
> Apologies for send this message to this list. I previous have sent
> this problem to debian.user.portuguese malling list, after to
> debian.user and, both, I don't receive a help that solve the problem.
> 
> Here is the threads:
> 
> in portuguese: http://thread.gmane.org/gmane.linux.debian.user.portuguese/105597
> 
> in English: http://thread.gmane.org/gmane.linux.debian.user/322839
> 
> Here is a screenshot of the last showed screen before powerdown:
> 
> http://www.divshare.com/download/4384152-861
> 
> Have you a tip for me?
> 
> Thank you very much!

Sounds like a Debian problem, trying to set acoustic management settings 
on a DVD drive is not something the init scripts or whatever they are 
should be doing. The aborted command error is expected because the drive 
doesn't support that command.

What was the actual problem you were seeing?
