Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZJVNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZJVNhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZJVNhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:37:38 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:61227 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZJVNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vWNTx2y02ukgid44T39EDPO2Ni3ECSAdl6jCUts9cCzGtppYCVMfyBbSkFTiHlntod
         ojizSI9WWZ7tS8sjZI6eiVmlk8XwMAaYe8L7meAS4dLoQzqdDuFxSBV/ZGqZx+6OQjCG
         AEDr7H+i9byIQes3xcoricObQMGF78cdwLJBI=
MIME-Version: 1.0
In-Reply-To: <20091022120613.GB4928@nowhere>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
	 <20091022112746.GA4928@nowhere>
	 <f22d86810910220443u49cdfabg83ef836406cfb36d@mail.gmail.com>
	 <20091022120613.GB4928@nowhere>
Date: Thu, 22 Oct 2009 06:37:42 -0700
Message-ID: <f22d86810910220637g1793c712q85231e7482712d@mail.gmail.com>
Subject: Re: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your explanation, this solves my problem.

-Leo.
