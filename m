Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZKBIbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZKBIbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZKBIbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:31:10 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54678 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZKBIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:31:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kZA4V5jkYVX7nnRtyTjmzZMMsIYcIwUyDNIVdXtKYLLJb5CtF2l5+Ll1HL3qkbcf8s
         WXXDGMNAQMhfSppMClo6E3HtaJUPk/3+ghY3FTs3ljLcoP6I+reVZE05NByASCF2n7MY
         ADM9qjlSZkjprPV7V6eDIYFC4sCADbAICQvmQ=
MIME-Version: 1.0
In-Reply-To: <200911010020.20284.rjw@sisk.pl>
References: <20091031160351.26fcc6c5@infradead.org>
	 <200911010020.20284.rjw@sisk.pl>
Date: Mon, 2 Nov 2009 08:31:12 +0000
X-Google-Sender-Auth: 1b53bfa9375d7209
Message-ID: <25d66d860911020031p6f7772d2w3aca808d25c6d7@mail.gmail.com>
Subject: Re: kerneloops.org report for the week of October 31 2009
From: Andy Whitcroft <apw@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-acpi@vger.kernel.org,
       tytso@mit.edu, netdev@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       akpm@linux-foundation.org, Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This should be fixed by commit 04bf7539c08d64184736cdc5e4ad617eda77eb0f
> (PM: Make warning in suspend_test_finish() less likely to happen), at least on some
> machines that report it.

That commit has been pulled back to the first 9.10 updates kernel to
reduce the noise.

-apw
