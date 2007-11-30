Return-Path: <linux-kernel-owner+w=401wt.eu-S935168AbXK3PXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168AbXK3PXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbXK3PX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:23:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:12706 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbXK3PXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uMoDYp4HA5yn+8HzITNxItgF1AUDsePzFo4JOZ4VjuL2TcgByR4HFnEAP5EtBUv4R+kR4mSx2aAv6iohyKYVLzlrql4qOn7M+Qe9jj2WH1ERwlGuYoEXejPMXJrdpvJxHj71iE18EeGXa8a5gE/wyP6pwwArqL3Fq+6/zVSQATg=
Message-ID: <b6fcc0a0711300723h35159d34m124817b7047b42f9@mail.gmail.com>
Date: Fri, 30 Nov 2007 18:23:22 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: git + checkpatch.pl?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <DF3E6A31-61AA-44B2-90C0-7001976E5691@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <DF3E6A31-61AA-44B2-90C0-7001976E5691@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/07, Kumar Gala <galak@kernel.crashing.org> wrote:
> Does any know if there is a way to run checkpatch.pl over the index
> before one does a commit?

Something like .git/hooks/pre-commit hook should work.

Alexey, who never used it.
