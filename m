Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYJVS5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYJVS5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbYJVSyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:54:46 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:36468 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263AbYJVSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EIqX5uWJ8ozVVtcPGNWVcdn2j3NJ0jj4PBH9agaLkBgbhxsYGIjKFc60mitfGkvfx0
         /LbdsFNxDekuMwOFvtTyyk8BgN7oVOpsbHzVM0ScusXnwsInMBkFqlTP9WQ1e3RQndXt
         ZEjcWH2VQ/lQ8HASh8sEObpMt56bObOj7y8lA=
Message-ID: <c62985530810221154s140d01d5id6e9fa952eb485a3@mail.gmail.com>
Date: Wed, 22 Oct 2008 20:54:42 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH][RESEND] tracing/ftrace: Introduce the big kernel lock tracer
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810221418380.13500@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FF5E54.7000101@gmail.com>
	 <alpine.DEB.1.10.0810221418380.13500@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will send a V2 to apply your comments.

Thanks!
