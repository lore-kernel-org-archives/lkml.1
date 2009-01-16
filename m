Return-Path: <linux-kernel-owner+w=401wt.eu-S937061AbZAPSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937061AbZAPSSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZAPSSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:18:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:6160 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZAPSSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:18:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,278,1231142400"; 
   d="scan'208";a="423007843"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] pci: __FUNCTION__ is gcc-specific, use __func__
Date: Fri, 16 Jan 2009 10:17:51 -0800
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1231374157.5586.32.camel@brick>
In-Reply-To: <1231374157.5586.32.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161017.51623.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 7, 2009 4:22 pm Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> I guess checkpatch isn't a string enough warning :-/

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
