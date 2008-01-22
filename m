Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYAVVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYAVVIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYAVVII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:08:08 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40674 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605AbYAVVIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:08:07 -0500
Date: Wed, 23 Jan 2008 00:07:41 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Fries <david@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080122210741.GB30938@2ka.mipt.ru>
References: <20080121231557.GA4025@spacedout.fries.net> <479541F5.9080705@zytor.com> <47955ECB.3050100@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47955ECB.3050100@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 07:11:07PM -0800, H. Peter Anvin (hpa@zytor.com) wrote:
> >Millikelvins would have the nice property of never being negative.  :)
> >
> 
> Alternatively, centikelvins would fit nicely in 16 bits if anyone cares...
> 
> 655.35 K = 382.20 œC = 719.96 œF

I have no objection on adding new sysfs files which will return
temperature relative to one on Mars or Venus :)

-- 
	Evgeniy Polyakov
