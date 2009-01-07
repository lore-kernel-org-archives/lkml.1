Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZAGRUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZAGRUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZAGRUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:20:34 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:52381 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZAGRUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:20:33 -0500
Message-ID: <4964E44F.3040609@knaff.lu>
Date: Wed, 07 Jan 2009 18:20:15 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patches applied to tip:x86/setup-lzma
References: <200901042146.n04LkGTC005829@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <496468EE.9000802@zytor.com>
In-Reply-To: <496468EE.9000802@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I just applied these three patches to the tip:x86/setup-lzma tree to
> resolve the build issues in some configurations.  The third and largest
> patch is a slightly modified version of Alain's last patch, the other
> two addresses the Kconfig chain.  Please review.
> 
> 	-hpa
> 
> 

Looks ok to me

Alain

