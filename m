Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZAKN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZAKN7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZAKN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:57:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:42043 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZAKN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VjvsXNm17cuTn+2Up/WEterLpDekyPjaXWmKKbQxZhR5RNIq9KLRbeLWlTX5oWFtWb
         EIAYAzCGGcVYULpDdobKyfsUvZ2IbrmstDN+qMHSmnCGnQHcqk02/hK0/BBuL1sD8aBZ
         qC42J0CEqTx2XF5JgjdgR5Ag5F6HZeY3CLyi0=
Message-ID: <b6a2187b0901110557xb696d03n9a7c7acad122e561@mail.gmail.com>
Date: Sun, 11 Jan 2009 21:57:46 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <oWTznAnH9BI.A.e4H.UHfaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <oWTznAnH9BI.A.e4H.UHfaJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-05 4:13 (7 days old)
> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4

Latest git pull still not fixed.

Jeff.
