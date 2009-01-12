Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZALWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZALWJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZALWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:07:51 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:40928 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbZALWHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KyMXTpJb2OqiIvGVdI71vKRHzt19wSE0E0+ZfEUxB5z3iPZRLQpz4eVjpYKPGfBwjJ
         iLTRIlvMaG9Uzhw9eABbGZ0sRE30h/Xo/Ka0gdfbTak1Ehg17k0azsCrRyRR8Zv43jOA
         Q+VpSgGdv/PJbrAJX8m2aP+wTNC8dPbe5h3kg=
Message-ID: <8bd0f97a0901121407ude0b816i2ebd36c3d24036e9@mail.gmail.com>
Date: Mon, 12 Jan 2009 17:07:48 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc cpumask_var_t's.
Cc: "Ingo Molnar" <mingo@redhat.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jack Steiner" <steiner@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090112220519.566749000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 17:05, Mike Travis wrote:
> Cc: Bryan Wu <cooloney@kernel.org>

Blackfin CC should be more uclinux-dist-devel@blackfin.uclinux.org
-mike
