Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZBGQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZBGQdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZBGQdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:33:16 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50187 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZBGQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:33:16 -0500
Date: Sat, 7 Feb 2009 16:33:06 +0000
From: Matthew Garrett <mjg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_script: rewrite using parse_shell_args()
Message-ID: <20090207163306.GB31938@srcf.ucam.org>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name> <1233866864-14422-2-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233866864-14422-2-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:47:43PM +0200, Kirill A. Shutemov wrote:
> parse_shell_args() allows to use more than one argument in shebang

Surely this changes userspace ABI?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
