Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXJAVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXJAVrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXJAVrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:47:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:48575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXJAVrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:47:06 -0400
From: Andi Kleen <ak@suse.de>
To: patches@x86-64.org
Subject: Re: [patches] [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Date: Mon, 1 Oct 2007 23:45:22 +0200
User-Agent: KMail/1.9.1
Cc: Joerg Roedel <joro@8bytes.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <200710011847.50533.andi@firstfloor.org> <20071001201222.GB1404@8bytes.org>
In-Reply-To: <20071001201222.GB1404@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012345.22851.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> feature flag does not disappear when its disabled. But because with CPUs
> having the SVM-lock feature it can be re-enabled in a secure way under
> some circumstances

Who would reenable it in what circumstances? 

-Andi

