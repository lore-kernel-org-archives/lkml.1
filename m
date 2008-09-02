Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYIBQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYIBQG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYIBQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:06:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:42845 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYIBQGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=SD0AMQLav3T7rGVB+a63P96SAB6km2mfFgS0B90BvGKRm9QT/gICUrmfF6n93hmc0y
         6swYm4PVyjsF7IZLtXi6lPU5nyXR6hDgxU8zJ4F5tPPZY6y4JRwnbcK+g1PyVMTgWlTw
         J3XC6wr5wZJUd06QcZNptGdtQMUZ8wE0h1cOU=
Message-ID: <48BD6473.80500@panasas.com>
Date: Tue, 02 Sep 2008 19:06:11 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BD626B.6070705@panasas.com>
In-Reply-To: <48BD626B.6070705@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops some checkpatch love missing see new patch

Boaz

