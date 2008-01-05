Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYAEQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYAEQjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYAEQi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:38:58 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:40572 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYAEQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:38:57 -0500
Message-ID: <477FB2A5.5010005@davidnewall.com>
Date: Sun, 06 Jan 2008 03:09:01 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [2.6.25 patch] remove a.out interpreter for ELF executables
References: <20080101134749.GJ2360@does.not.exist> <200801011536.32598.ak@suse.de> <20080105013053.b46cd28b.akpm@linux-foundation.org> <20080105094618.GA2304@does.not.exist>
In-Reply-To: <20080105094618.GA2304@does.not.exist>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 15:36:32 +0100 Andi Kleen <ak@suse.de> wrote:

> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-aout-interpreter
>
> Also removal of the old unused iBCS hooks while I was on it
>
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-ibcs-support

Is iBCS support the basis for SCO & SVr4 support?  (These both sound 
useful.)
