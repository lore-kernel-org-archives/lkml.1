Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZKSRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZKSRW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZKSRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:53 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:27197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbZKSRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bTG8i67hAffSk5T1hsn+kmAv+hqt7KKs89bFtXNLT0HqYC8uPmMUkHfoc7RphGb/Ou
         bzjMNQkD42jX5RxlsC5oSFPqffijy+ucW0TlP2+TkRVoV2Psnh7MMXAxdqyWgH31GTnW
         qJqRXu8R1qT/A/82p2DbygMvGlYpdC4TYFX5o=
MIME-Version: 1.0
In-Reply-To: <d0ced6d70911190416w3a354a50jcb0e93934805ca07@mail.gmail.com>
References: <d0ced6d70911190416w3a354a50jcb0e93934805ca07@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 19 Nov 2009 12:22:34 -0500
Message-ID: <3e8340490911190922s55e54a91i273b47f61b113710@mail.gmail.com>
Subject: Re: Crash 2.6.19
To: bluedefense bluedefense <bbbluedefense@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 7:16 AM, bluedefense bluedefense
<bbbluedefense@gmail.com> wrote:
> Hi, I really dont know if this is the right mailing list. But I have a
> really serious problem with the linux kernel on a production server.
> The kernel version is 2.6.19 and the following is my config:

That's a three year old kernel version - I don't know if anyone's
going to be very inclined to try to debug it. I'd recommend trying to
upgrade to a more recent version.
