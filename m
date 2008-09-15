Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbYIOSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbYIOSck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYIOScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:6991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYIOScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=RhPOM0ceQzUw+XQsyz6T3xGFRtSCBwMbYgQcy76mJ3mW+Kan2QklTGsvm8JpJ3WCMk
         AY0ey4q92nubV2Q6mjQiA5EmFRPTB5EHkT71R6eE9oUy6Xk0yxOamoa0cdZ9CRuh2xvC
         RIRSWAZuDylUDnXHVfOv+w4R56XSan1b22nJY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 04/10] ide-atapi: assign taskfile flags per device type
Date: Mon, 15 Sep 2008 19:54:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809151954.53704.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:52 Borislav Petkov wrote:
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
