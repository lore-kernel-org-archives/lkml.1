Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXEJG5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXEJG5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXEJG5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:57:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXEJG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:57:14 -0400
Date: Thu, 10 May 2007 07:57:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 01/10] Linux Kernel Markers - Add kconfig menus for the marker code
Message-ID: <20070510065709.GC8019@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Adrian Bunk <bunk@stusta.de>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.320910031@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020915.320910031@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig additions come last because every patch in the series
should be buildable.   

