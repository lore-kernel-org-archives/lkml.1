Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYF0LGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYF0LGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYF0LGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:06:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYF0LGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rf6eU9T+yD1BPDqJlBxuvMduFmE9SHaQ4vErdRRAkAkpshEiPiwK8X0OjrkNqVPuvH
         5yuJvWizk6jDYEz0N4EeGtC1aILibNtovsOyN9Ea4v7miIzZcRob5Rgx7v0cHBABEjb9
         m8Spu90wmeXQYisWOKefd8YPMV3hV7zEeWyKU=
Message-ID: <e2e108260806270405u28cb14bcl46713157a5ef4155@mail.gmail.com>
Date: Fri, 27 Jun 2008 13:05:58 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Mayank Sharma" <mayanks@sirf.com>
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm@lists.arm.linux.org.uk
In-Reply-To: <013B1C915F9462459242424413ABB264011AC7AC@bnglmail.sirf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260806252347m7a6b114by5b5100a86ce35a55@mail.gmail.com>
	 <013B1C915F9462459242424413ABB264011AC7AC@bnglmail.sirf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:00 AM, Mayank Sharma <mayanks@sirf.com> wrote:
> I have observed this behaviour on 2.6.23-17. The diff in my earlier mail was with the latest kernel.
>
> I am cc'ing linux-arm on this mail. In my opinion the problem was not restrictive to ARM and hence I posted this message in the linux-kernel list.

Have you already been able to verify  this ?

Bart.
