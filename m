Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXCGPIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXCGPIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXCGPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:08:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXCGPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:08:35 -0500
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
From: Arjan van de Ven <arjan@infradead.org>
To: vgoyal@in.ibm.com
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
References: <20070307065703.GA23412@in.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 07 Mar 2007 07:07:39 -0800
Message-Id: <1173280059.3540.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 12:27 +0530, Vivek Goyal wrote:
> Hi,
> 
> Here is another attempt on x86_64 relocatable bzImage patches(V4). This
> patchset makes a bzImage relocatable and same kernel binary can be loaded
> and run from different physical addresses.


have these patches been extensively tested with various suspend
scenarios? (S1,S3,S4 in acpi speak or s2ram and s2disk in Linux speak)

