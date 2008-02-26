Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbYBZW1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbYBZW1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765327AbYBZWXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24013 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764865AbYBZWXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YKyn0lYjLCVpV2YmrP0wqmY1qqGQkyCBjGTRxhmudvUFX3Au3bAYTBWALn3yK9XgKNa3ZyoUXXd7+4m7L7RQIn5EM7A/4STX4QVqpuJxVQji8JCSKz1fqukwIq52Mhh8kspa1kKslKDZrcbLx5w1znbfWkE1QqfPKY31x3lnlog=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH] ide-cd: put proc-related functions together under single ifdef
Date: Tue, 26 Feb 2008 23:25:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204012194-4208-1-git-send-email-petkovbb@gmail.com> <1204012194-4208-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204012194-4208-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262325.15917.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
