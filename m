Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025Ab0AGMXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab0AGMXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529Ab0AGMXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:23:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0AGMXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:23:23 -0500
Date: Thu, 7 Jan 2010 13:23:21 +0100
From: Michal Marek <mmarek@suse.cz>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genksyms: close ref_file after use
Message-ID: <20100107122321.GA16853@sepie.suse.cz>
References: <1262830961-29911-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262830961-29911-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 05:22:41AM +0300, Alexander Beregalov wrote:
> It is the last place when the file is read, so close it.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Applied, thanks.

Michal
