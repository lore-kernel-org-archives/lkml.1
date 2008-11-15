Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYKOKi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYKOKi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYKOKis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:38:48 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:8577 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYKOKis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:38:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WAfk6v5VQLloGFTwSzmo9KgGXWVD7pePB5WYsOqBx0CpfGtbvbZ75a3NoVX3GHf5N3
         xajyLXNkl/F7r4+9Lg40UVb9oyXZ0barWYcbgF4HMsd67l/Ui126D8j9p5RM3BAwi+w+
         UMzUPX2wK9cYcYieByw0cwK15qMNT80koiNDg=
Message-ID: <9b06e8d20811150238ye81f6dck7e81e275ba11da9d@mail.gmail.com>
Date: Sat, 15 Nov 2008 11:38:47 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Linux 2.6.27.6
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20081113185350.GA3765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081113185350.GA3765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    No big deal, but commit 093327cb references
  X86_CHECK_BIOS_CORRUPTION that is not available anywhere.

      Thanks,

            Loïc
