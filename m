Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYKCRfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYKCRfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYKCRfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:35:21 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:36086 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKCRfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IeH9Q8sAikqZnfzUqdrnaa5nU+kXdMmHfHzqxCPhrfJvwHocw+B4NePMJLrrq+h7T1
         SQI7uaFgH4XjScDfabh6NXBgYCTtz+PZJx8uctpHN5hHUgM3b/UTm5C9elt5brfeas19
         TZS6szejzUfyWV8AwTI9IzDn3R+sq9rs2/0yg=
Message-ID: <1aad82fa0811030935k37e9e5a6u80df88311aa3c532@mail.gmail.com>
Date: Mon, 3 Nov 2008 12:35:17 -0500
From: "Mike Frysinger" <vapier@gentoo.org>
To: "Nicolas Pitre" <nico@cam.org>
Subject: Re: [PATCH] SMC91x: delete unused local variable "lp"
Cc: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0811031154270.13034@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
	 <20081104.014511.108120668.anemo@mba.ocn.ne.jp>
	 <alpine.LFD.2.00.0811031154270.13034@xanadu.home>
X-Google-Sender-Auth: 8ae33a92e1623bc7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you need to revert both functions.  David Miller has already posted a
patch which adds warning markers instead.
-mike
