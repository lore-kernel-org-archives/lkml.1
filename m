Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYAGLej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYAGLej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYAGLea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:34:30 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:35239 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbYAGLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H2eVvPPZxwCcPRVel7F1WpxMj44gMdXG2XwcwZlDaaR9XamjEX8T3+hikiAneEfw8LMOsn3j8n0CldOX6CyqMzaDct3U3GSvO6CaNFjQ9+WQF+sQHIA+fGw7+u4ln1xzb2AEoHYR2hSb99JJ9gTLjrnYgp0ltvnAjf9aTBNaiyU=
Message-ID: <4d8e3fd30801070334t30e4a051u6ab252f5a4b9df44@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:34:28 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, "hpa@zytor.com" <hpa@zytor.com>
Subject: [PATCH] 0/5 Codying style fixes in ./arch/x86/ia32
Cc: "Ingo Molnar" <mingo@elte.hu>, trivial@kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080105211414.1fe6c98d@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080105211414.1fe6c98d@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following 5 patches fix 227 errors and 2 warnings
reported by checkpatch.pl



--- BEFORE ---
ia32_signal.c
total: 96 errors, 11 warnings, 617 lines checked

ia32_binfmt.c
total: 41 errors, 5 warnings, 285 lines checked

ia32_aout.c
total: 50 errors, 18 warnings, 528 lines checked

fpu32.c
total: 39 errors, 1 warnings, 183 lines checked

audit.c
total: 1 errors, 0 warnings, 42 lines checked

Total
total: 227 errors, 35 warnings


--- AFTER ---
ia32_signal.c
total: 3 errors, 9 warnings, 617 lines checked

ia32_binfmt.c
total: 2 errors, 5 warnings, 285 lines checked

ia32_aout.c
total: 2 errors, 18 warnings, 526 lines checked

fpu32.c
total: 2 errors, 1 warnings, 183 lines checked

audit.c
total: 0 errors, 0 warnings, 42 lines checked

Total
total: 9 errors, 33 warning


-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
