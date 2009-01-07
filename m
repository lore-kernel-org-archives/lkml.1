Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZAGOkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZAGOkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbZAGOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:39:50 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:65521 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbZAGOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RkBgvrA0V92PqlMfKAdepeD4t42xhK40rV4IoPTRwVsAKhAF8xJ07gGD5+uE+MQ4hW
         wePJqT04Vw6ksW4DT8JSwGePY1ciDJk4MuT7AAmqmw1bvkCS7/4voOzY8hFtc0ENMBiA
         0bqj3Tp13Gw9JQx4Ruc6PZ7GslGoUjAtWroRo=
Message-ID: <4964BEB0.7040400@gmail.com>
Date: Wed, 07 Jan 2009 15:39:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-07-00-23 uploaded
References: <200901070828.n078SRKJ024599@imap1.linux-foundation.org>
In-Reply-To: <200901070828.n078SRKJ024599@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2009 09:28 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-07-00-23 has been uploaded to

Hi,

there is wrong parenthesis pairing added in:
patches/mm-add-proc-controls-for-pdflush-threads-fix.patch
which causes a build error.
