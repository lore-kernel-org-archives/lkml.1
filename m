Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbXFSJKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbXFSJKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbXFSJKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:10:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:22525 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXFSJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQXjdJ5bsHgQGydhUpP/FOChcLJkAYahagOYHNISKfqtaJaB8yykgkfaLd+YpbsZ7JrssEo2IGGX9z80ekVGDYUG10OePKQ38229Vka/59WZJ2o+WTe4Q7Z0uEJEKFZPaendy6ZjMPe6Xy5MKIPZZng7E99SAVYUCOswD/TUDK0=
Message-ID: <46a038f90706190209h7cbde42h34d6ac819711c3d3@mail.gmail.com>
Date: Tue, 19 Jun 2007 21:09:58 +1200
From: "Martin Langhoff" <martin.langhoff@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: Versioning file system
Cc: "Bryan Henderson" <hbryan@us.ibm.com>,
       "Jack Stone" <jack@hawkeye.stone.uk.eu.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, alan <alan@clueserver.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, git@vger.kernel.org
In-Reply-To: <6E9A6F9E-8948-40F2-9129-1F1491D49D83@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF7FA807A1.64C0D5AF-ON882572FE.0061B34C-882572FE.00628322@us.ibm.com>
	 <6E9A6F9E-8948-40F2-9129-1F1491D49D83@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> What I think would be particularly interesting in this domain is
> something similar in concept to GIT, except in a file-system:

perhaps stating the blindingly obvious, but there was an early
implementation of a FUSE-based gitfs --
http://www.sfgoth.com/~mitch/linux/gitfs/

cheers,


martin
