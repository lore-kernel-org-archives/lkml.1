Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYHYRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYHYRYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYHYRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:24:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:12481 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYHYRYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ryCd37K8hVPGRgV5edgx32ybYWrNTa0xOdkXzn3DRTH6rfxegAI7Q+Rnsk/9PSF0Pi
         fDO7VvcX3UgBwN+GBZiVIdcQUNcLNhnLNFqU+2r9W24hmJ3rkBeQKm2PsEyCNDTxj1Eh
         XtrtoTssi1l4je+vUrjD4Y4ZWDnUEoAzoOgl4=
Message-ID: <86802c440808251024j6bbf6996h61e2817e0f597074@mail.gmail.com>
Date: Mon, 25 Aug 2008 10:24:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <198846.67567.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <198846.67567.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 6:39 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> this one should work. please apply this one only.
>
> Oops.  Didn't read all my emails first... went through inbox
> one-at-a-time.  (When will I ever learn?...  ;)
>

if your mail client support threading, your life will be much easier.

YH
