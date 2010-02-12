Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0BLPZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:25:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0BLPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:25:21 -0500
X-Authority-Analysis: v=1.0 c=1 a=uTOmaDeAZlAA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=nuhponIAdsgpKU-lRAUA:9 a=7n3OVfoBkePgbsD1qPUVTZKn_i4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jean Delvare <khali@linux-fr.org>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
In-Reply-To: <20100212150137.648dca7c@hyperion.delvare>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Feb 2010 10:25:18 -0500
Message-ID: <1265988318.24271.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 15:01 +0100, Jean Delvare wrote:

> I wouldn't worry too much about breaking the current locations. Just
> give some time for software authors (ketchup comes to mind) to update
> their code and it shouldn't be a big problem.

As the new maintainer of ketchup:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/ketchup.git

I could write a fix for the new format real quick. My concern is that
users of ketchup may not see this update for a long time.

-- Steve


