Return-Path: <linux-kernel-owner+w=401wt.eu-S935428AbYEVKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428AbYEVKVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762570AbYEVKUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:20:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59251 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762016AbYEVKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:20:55 -0400
Message-ID: <483548FD.30703@pobox.com>
Date: Thu, 22 May 2008 06:20:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Brice Goglin <brice@myri.com>, Andrew Gallatin <gallatin@myri.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make myri10ge_get_firmware_capabilities() static
References: <20080519215300.GC17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519215300.GC17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global 
> myri10ge_get_firmware_capabilities() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied


