Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYIZN07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYIZN07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYIZN0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:26:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:29866 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIZN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GHzkePhxk4sJRpcYmCwgnJsFtxSe3SB4JPLFqXMJYDcW9uUc234gqqcIFA3qcM9gvG
         PNy+OOZ1Y1q/l3nt98EAZU/8nRA6drTR4TpdJkohVX7941tU6WWOHUOgCplPL1JrpzcW
         b5ogHPDJEboMDYprrofr/PRXi7Zdi1EodQPkw=
Message-ID: <e8ca35370809260626j5e55e0d8n4d33fb6542a48d48@mail.gmail.com>
Date: Fri, 26 Sep 2008 15:26:50 +0200
From: "Pascal Terjan" <pterjan@gmail.com>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: Turning off camera also kills card reader on EeePC 900
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Corentin Chary" <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <e8ca35370809260356l569f248dya77c8a3d9586c21c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <579556.5870.qm@web38203.mail.mud.yahoo.com>
	 <e8ca35370809260356l569f248dya77c8a3d9586c21c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 12:56 PM, Pascal Terjan <pterjan@gmail.com> wrote:
> I have just tried with latest git and it seems to work fine !

just for information, rc7 + 5257d97a219e17abf8188f136e1189da3b3af33c is OK too
