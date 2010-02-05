Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab0BESxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:53:19 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:62107 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601Ab0BESxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:53:18 -0500
Message-ID: <4B6C6919.9020407@billgatliff.com>
Date: Fri, 05 Feb 2010 12:53:13 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 0/5] Implements a common PWM API
References: <cover.1265094517.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE1909020E99C5@mi8nycmail19.Mi8.com> <BD79186B4FD85F4B8E60E381CAEE190902152C2F@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902152C2F@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>
> When you do repost this series please make sure that pwm support can only be
> selected if CONFIG_SYSFS is enabled.  Your original patches did not have this.
>   

Hmmm.  You mean CONFIG_SYSFS isn't pretty much mandatory nowadays?

> BTW, setting pwm.dev = &pdev->dev in my driver did fix the Ooops.
>   

Glad to hear that!  I'm hoping to get updated patches out next week.


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

