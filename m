Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZEHHn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZEHHn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZEHHnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:43:18 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49934 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZEHHnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:43:18 -0400
Date: Fri, 8 May 2009 09:45:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 07/14] x86, boot: simplify arch/x86/boot/compressed/Makefile
Message-ID: <20090508074527.GE12808@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-8-git-send-email-hpa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735222-6640-8-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:26:55PM -0700, H. Peter Anvin wrote:
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Simplify the arch/x86/boot/compressed/Makefile, by using the new
> capability of specifying multiple inputs to a compressor, and the
> CONFIG_X86_NEED_RELOCS Kconfig symbol.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Very nice cleanup!
