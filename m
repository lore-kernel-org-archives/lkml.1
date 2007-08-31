Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXHaOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXHaOkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXHaOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:39:57 -0400
Received: from lazybastard.de ([212.112.238.170]:57009 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbXHaOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:39:56 -0400
Date: Fri, 31 Aug 2007 16:35:28 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Message-ID: <20070831143527.GB5328@lazybastard.org>
References: <46D5F462.9010401@redhat.com> <200708311211.25143.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708311211.25143.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 August 2007 12:11:25 +0100, Denys Vlasenko wrote:
> 
> KSYM_NAME_LEN = 128 sounds stupid. The name which is wider than 80 chars??
> Kernel shouldn't have names that long.
> Say, 50 chars ought to be enough.

Might be an enforcement problem, unless someone also writes a
check_name_len.pl or so.

Jörn

-- 
The rabbit runs faster than the fox, because the rabbit is rinning for
his life while the fox is only running for his dinner.
-- Aesop
