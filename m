Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXJ0PzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXJ0PzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXJ0Py4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:54:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:19688 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXJ0Pyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hYnBEf1fhMIyCwBVDSc6pBQrpl2EXEjj7pZEfbKXhtND2x6k5+nj14TP36demBuS+i0HIv36+R3Dk7HFnvihS8uf247F/XPYPZ1J/PAvyz/d3fMlsrhSAG5E69SXxH7/cpz++LbVeA8kVXEuZomKpglbPielgFaFZCIZAHtlatk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] unexport ide_fix_driveid
Date: Sat, 27 Oct 2007 17:58:05 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20071027141833.GT30533@stusta.de>
In-Reply-To: <20071027141833.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271758.06427.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007, Adrian Bunk wrote:
> ide_fix_driveid can now be unexported.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
