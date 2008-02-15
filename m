Return-Path: <linux-kernel-owner+w=401wt.eu-S932731AbYBOImH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbYBOImH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764989AbYBOIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:41:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:30153 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbYBOIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n470HZIPMVWjjhXCLzf8W4vsq2CYeIsgTtxT+6nlL/cabuVFmAliatgFbOPb8F6bZAimXmyu2U1ndI9RcYtfPAiHIZmJVTi8tXDcFn0YYRAZKpEnHJ9TXhKSZey5OHjiypRXYrzPJF+AN8iUMFivF2694tfaq8w9UpsuY/67+kY=
Message-ID: <86802c440802150041x3a9f3e61na12cd1661696ec5e@mail.gmail.com>
Date: Fri, 15 Feb 2008 00:41:43 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Ingo Molnar" <mingo@elte.hu>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080215065230.GA8625@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802122139.14840.elendil@planet.nl>
	 <20080212205622.GA21986@suse.de>
	 <200802131239.14305.elendil@planet.nl>
	 <20080213165837.GA10129@suse.de>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080215065230.GA8625@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:52 PM, Greg KH <gregkh@suse.de> wrote:
>
>  Ugh, sorry, I was mistaken, it's not a cpufreq issue, it's a
>  CONFIG_DETECT_SOFTLOCKUP issue.  Or that is what I was told before.
>

could  be two issues:
one in cpufreq, and one in detect softlockup...

YH
