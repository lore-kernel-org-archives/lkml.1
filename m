Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYJCRnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYJCRnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJCRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:43:39 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:31658 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYJCRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=L+SSm6MS2bqNlEX5XfS1NMsxZMNBJREh1CPdTz7ojtEGLby/09nEGdBWP3+y9tpZDC
         kpLaTFZaiaZy00Z73CTFcS45M5PT5cXP1SpEB2yDesPCmbSEpMMbyemivlhZmDbgXxra
         ML7e4bHWPlT5uu13glIN/UGYYOW2LVYsWF8qQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/3] ide-cd: debug log enhancements
Date: Fri, 3 Oct 2008 19:15:40 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com> <1222669799-6565-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1222669799-6565-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031915.41344.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2008, Borislav Petkov wrote:
> Add some more verbosity to key function calls in ide-cd debug code. While at it,
> delete a superfluous comment.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
