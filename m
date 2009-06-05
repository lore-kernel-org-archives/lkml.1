Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZFEPW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZFEPW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZFEPWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:22:17 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43156 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZFEPWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KhVCdeHbH3V21rxOqz0avUqWfMLiGrnXdwtsCVtK9IRg/8jJlz44paXo2ESDcpvNkJ
         vtmjoBKV6SCclM2JOFV3Is/U3zCSMKRs5di/Fl80fAOoIH++QtKdLG78iTwqQTnH72vc
         fGd5eLY72YkqXaaFDSKFI5CEdvF1skXX1Aj80=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0906051112370.10297-100000@netrider.rowland.org>
References: <4A2931F5.1090709@tuffmail.co.uk>
	 <Pine.LNX.4.44L0.0906051112370.10297-100000@netrider.rowland.org>
Date: Fri, 5 Jun 2009 18:22:15 +0300
X-Google-Sender-Auth: afd7a54158babfad
Message-ID: <84144f020906050822x46c4f9cbmbad7ff6a2942c174@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, 5 Jun 2009, Alan Jenkins wrote:
>> Auto-suspend white-listing would be done on the basis of USB ids
>> (vendor, product).  At the moment it's expected that userspace should
>> take ownership of it.  There's no infrastructure for in-kernel
>> whitelisting.  I think.

On Fri, Jun 5, 2009 at 6:13 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
> That's right.  We found it was hopeless to try doing this in the kernel
> so we dumped the whole mess into userspace.

:-)

I prefer that the kernel takes care of this things because, quite
frankly, I usually end up fighting with user-space more than I ever do
with the kernel. But don't mind me, I really have no say in USB
development. I am just happy to have a working camera and can hand
over the laptop back to my better half :-).

                        Pekka
