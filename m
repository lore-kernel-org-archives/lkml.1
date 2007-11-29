Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbXK2S7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbXK2S7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbXK2S7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:59:44 -0500
Received: from neopsis.com ([213.239.204.14]:58914 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759873AbXK2S7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:59:43 -0500
Message-ID: <474F0C0E.8000109@dbservice.com>
Date: Thu, 29 Nov 2007 19:59:26 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?] OSS: fix operator precedence in return of btaudio_dsp_ioctl
References: <474F02B2.6010406@tiscali.nl>
In-Reply-To: <474F02B2.6010406@tiscali.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.27,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> First of all, is /sound/oss/* still maintained?
> 

Documentation/feature-removal-schedule.txt

What:  drivers depending on OSS_OBSOLETE
When:  options in 2.6.23, code in 2.6.25
Why:   obsolete OSS drivers
Who:   Adrian Bunk <bunk@stusta.de>

tom
