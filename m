Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbZHEBkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbZHEBkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbZHEBkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:40:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbZHEBkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:40:09 -0400
Message-ID: <4A78E229.2030309@zytor.com>
Date: Tue, 04 Aug 2009 18:36:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       linux@arm.linux.org.uk, alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 3/6] Add support for LZO-compressed kernels
References: <20090731093107.GA29704@merkur.ravnborg.org>	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>	<1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>	<1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <20090804160043.82b256d8.akpm@linux-foundation.org>
In-Reply-To: <20090804160043.82b256d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 04:00 PM, Andrew Morton wrote:
> 
> 0.24 seconds booting speedup sounds pretty thin.  Adding a new
> decompression format will introduce more configuration/build/deployment
> complexities.  How do we justify this?
> 

Keep in mind this may be out of a 3-5 second boot budget.

	-hpa
