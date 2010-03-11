Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0CKHJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:09:55 -0500
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:60931 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab0CKHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:09:53 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: arlan: fixed coding style issues in arlan-proc.c (etc...)
Date: Thu, 11 Mar 2010 08:09:50 +0100
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, git@vger.kernel.org, andre.beat@gmail.com,
       linville@tuxdriver.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <1268276306-14324-1-git-send-email-andre.beat@gmail.com> <1268278090.1674.37.camel@Joe-Laptop.home> <20100311033248.GA3832@suse.de> <20100311033248.GA3832@suse.de> <1268282459.1674.43.camel@Joe-Laptop.home>
In-reply-To: <1268282459.1674.43.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003110809.52037.elendil@planet.nl>
X-OriginalArrivalTime: 11 Mar 2010 07:09:52.0474 (UTC) FILETIME=[D871F3A0:01CAC0E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2010-03-10 at 19:32 -0800, Greg KH wrote:
>> He did, it's a "issue" with git-send-email that if you don't have empty
>> lines, it puts it all on the Subject: line.
> 
> Could you detail a bit more your problem description?

A normal commit description would be:
   <subject>

   <description>

   <signed-off-by>

You get the "running subject" effect if instead you do:
   <subject>
   <description>
   <signed-off-by>

I.e, if you omit an empty line after the subject line.

Cheers,
FJP
