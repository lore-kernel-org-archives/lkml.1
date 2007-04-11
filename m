Return-Path: <linux-kernel-owner+w=401wt.eu-S1030587AbXDKUhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587AbXDKUhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXDKUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:37:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:45839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbXDKUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=khbh0OnqwTyyTRzxj9TrRmP5NvUPSkSCO6LjLfNfh0WKrDgxBIapCr/UZzabuTLU6Hoj3yiS8LajT2tS6ZUaZX9VRItU68FvFcgqFkrNrkFNJ/Op0dw9BueIxY1YjvV31KJRTTTeBg/5mIPp1Gk2uIPWeTeN0INQLwLJ4IHugXU=
Message-ID: <461D46EF.2040805@gmail.com>
Date: Wed, 11 Apr 2007 22:37:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
References: <2189310342910921713@karneval.cz> <20070411132053.899462b4.akpm@linux-foundation.org> <461D45CE.3030309@gmail.com>
In-Reply-To: <461D45CE.3030309@gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Side note, as Danny wrote, there is an asus-laptop driver sitting in -mm,
> which supersedes this one -- if you plan to push it upstream in the near
> future, don't bother with this patch.

Hmm, there is a 0.40 version in -rc6 yet. There is something weird with me
today.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
