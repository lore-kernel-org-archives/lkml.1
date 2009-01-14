Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbZANI2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbZANI2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbZANI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:28:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756292AbZANI2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:28:07 -0500
Date: Wed, 14 Jan 2009 00:27:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew S. Johnson" <andy@asjohnson.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: TMDC Joystick no longer works in kernel 2.6.28
Message-Id: <20090114002757.6ef66074.akpm@linux-foundation.org>
In-Reply-To: <200901101553.40515.andy@asjohnson.com>
References: <200901101553.40515.andy@asjohnson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-input)

On Sat, 10 Jan 2009 15:53:40 -0600 "Andrew S. Johnson" <andy@asjohnson.com> wrote:

> Up through kernel version 2.6.27.9 I have had no problems with
> my joystick on the game port.  Now with 2.6.28, the game port
> is recognized when the gameport and ns558 modules load, but
> loading the tmdc module doesn't also automatically load joydev,
> and even loading joydev manually doesn't give me a working
> joystick.  There are no error messages in dmesg, /var/log/messages, 
> or /var/log/syslog.  This is on Slackware 12.1, so I don't think
> it's a distro issue.  Do I need to do something different than
> in the past to make it work, or is there some debug I can turn
> on to give more info?
> 

If this doesn't get resolved with a few days, please raise a report at
bugzilla.kernel.org, so that we can not fix it in a more organised
fashion, thanks.

