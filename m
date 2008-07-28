Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYG1Pan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYG1Pan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYG1Pad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:30:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:26413 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYG1Pac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZcI3HdwKG8ghElWugk2KS70P3xo3MjyaOmq9LTgSRJd+tSa4IRTh1WR5IKAwK4TorW
         HsGyS3Q8/2fEHe17eFGSTkx4gxu8ijcyA55s9g+veyfGiMTz2Y5W92AfjqjmD5Fc/yWb
         0mb12gH9kb2GnmQbLdHftdLF/qmooSLHm+aoQ=
Date: Mon, 28 Jul 2008 19:30:29 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Narendra Prasad Madanapalli <narendramind@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: 64-bit rlimits
Message-ID: <20080728153029.GA14188@martell.zuzino.mipt.ru>
References: <85e5430e0807280821k1ec1f990te815c8eb4de19b61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e5430e0807280821k1ec1f990te815c8eb4de19b61@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having in-kernel 32-bit AND 64-bit rlimits is plain wrong, sorry.

