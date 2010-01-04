Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199Ab0ADXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0ADXeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184Ab0ADXeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:34:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab0ADXeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:34:17 -0500
Message-ID: <4B427AF5.2030805@redhat.com>
Date: Mon, 04 Jan 2010 18:34:13 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Scott Davilla <davilla@4pi.com>,
       Naren Sankar <nsankar@broadcom.com>,
       Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
References: <20100104230227.GA14314@redhat.com> <20100104231949.GA14496@kroah.com>
In-Reply-To: <20100104231949.GA14496@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/10 6:19 PM, Greg KH wrote:
> On Mon, Jan 04, 2010 at 06:02:27PM -0500, Jarod Wilson wrote:
>> This patch supersedes the earlier ones sent by Manu Abraham to add
>> the Broadcom Crystal HD driver to the staging tree, per discussion
>> with him about it. I've been working with Broadcom's Naren Sankar
>> on this driver for a number of months, and had already talked Naren
>> about submitting this on Broadcom's behalf, didn't expect anyone
>> else to jump on submitting it as quickly as Manu did. ;)
> 
> Looks good, I'll queue it up tomorrow.

Nb: it looks like the thing is so massive (~935k), its not showing up on
lkml (at least, not in a timely fashion), so for the interested:

<http://people.redhat.com/jwilson/misc/broadcom-crystalhd-decoder-driver-staging.patch>

Thanks much!

-- 
Jarod Wilson
jarod@redhat.com
