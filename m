Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbYBMWeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbYBMWeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbYBMWdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:33:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:17733 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbYBMWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HmfvN70TrLcKkP4ZmkD6MqMlZ0NBG5g6UgUzUI78AEwDlUQCMND9tF4Q6kYsBg0zLUyF3pcRKNpmxqkwhNmfD5rOgk/a398A7AevivoJYY4ablnwzOJzyJOqOAnjiFvy395LNBs69e1HrySKXzJ7F5QG60yGnAaL+6yORgBSayQ=
Message-ID: <3aa654a40802131433m1ee34ea4n772f864e2fc9219b@mail.gmail.com>
Date: Wed, 13 Feb 2008 14:33:25 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Robert Hancock" <hancockr@shaw.ca>,
       "Andrew Morton" <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       shaohua.li@intel.com, trenn@suse.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
In-Reply-To: <200802051312.47074.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no>
	 <200802050003.32591.bjorn.helgaas@hp.com>
	 <alpine.LFD.1.00.0802051013110.9374@woody.linux-foundation.org>
	 <200802051312.47074.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 12:12 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> I'll play with your insert_resource() idea and see if I can figure
> something out.

Any word on this yet?

Thanks!
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
