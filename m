Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYAKKYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYAKKYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYAKKYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:24:47 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:45785 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYAKKYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:24:46 -0500
Date: Thu, 10 Jan 2008 22:18:45 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080110221845.GB20875@linux-mips.org>
References: <20080101134809.GK2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101134809.GK2360@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:48:09PM +0200, Adrian Bunk wrote:

Definately NAK for the MIPS segments.  Some of the EXPERIMENTAL
dependencies should be removed but many options tagged with EXPERIMENTAL
are still dangerous.

  Ralf
