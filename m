Return-Path: <linux-kernel-owner+w=401wt.eu-S933171AbYBTPfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbYBTPfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbYBTP3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:29:42 -0500
Received: from lazybastard.de ([212.112.238.170]:44700 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbYBTP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:29:41 -0500
Date: Wed, 20 Feb 2008 16:29:10 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2.6.25-rc2] block2mtd: logging typo fixes
Message-ID: <20080220152910.GB5539@lazybastard.org>
References: <chaz20080220150021.GM4539@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080220150021.GM4539@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 February 2008 15:00:21 +0000, Stephane Chazelas wrote:
> 
> this patch addresses a number of small issues mainly regarding
> the output made by this driver to dmesg:
>   - Some of the blkmtd's had not been changed to block2mtd which
>     caused display problem
>   - the parse_err() macro was displaying "block2mtd: " twice
> 
> Signed-off-by: Stephane Chazelas <stephane.chazelas@emerson.com>
Acked-by: Joern Engel <joern@lazybastard.org>

David, please apply.

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
