Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbXFOMg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbXFOMg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXFOMgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:36:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:28363 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbXFOMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=upHuXxH+mpYTWwiVVKdWsOpifcKhC83HRV75eqNUAwfWPPG1U63Rsk6tQhwwLpuk7+jTG7g4IYfTcE3I8q0tF3FbVNGUvW8z72uDsEYfRqV92kQT2nMtRVagv5C4lvcgFveVSGrWQAL3KFHGbW6dtqlNrFUZkCF9Uua/wt3msTo=
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
From: Richard Hughes <hughsient@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070614195659.GE9442@ucw.cz>
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz>
	 <87fy4vmxva.fsf@goat.bogus.local>  <20070614195659.GE9442@ucw.cz>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 13:35:46 +0100
Message-Id: <1181910946.4819.9.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 19:56 +0000, Pavel Machek wrote:
> 
> noapic/nolapic will not help with video issue. try s2ram from
> suspend.sf.net. 

Also there is (unashamed plug)
http://people.freedesktop.org/~hughsient/quirk/

Richard.

