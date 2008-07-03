Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYGCRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYGCRI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYGCRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:08:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:4753 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYGCRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Airxg+VlsX1Ih1f21kIgV2tvVT2GpUcKrne7Mj5HEgDwNeRxLRa/JuReSe7NZiOiET
         +mOcNdDQqA9cjSI/JIDsDB4XaSqTOH1IKX9XD1NtyzOO8hTju8HUrh4iIgGqImMejuEr
         7u72AAq5kAv6Vn9N7gDEMCVV3yofQoQ8IBU5M=
Message-ID: <e2e108260807031008r3de9aad7v8222d41fd750b9da@mail.gmail.com>
Date: Thu, 3 Jul 2008 19:08:48 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Linux 2.6.25.10
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080703035807.GA8190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703035807.GA8190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 5:58 AM, Greg KH <gregkh@suse.de> wrote:
> We (the -stable team) are announcing the release of the 2.6.25.10
> kernel.
>
> It contains a number of assorted bugfixes all over the tree.  And once
> again, any users of the 2.6.25 kernel series are STRONGLY encouraged to
> upgrade to this release.

Hello Greg,

Thanks for all the work you and the stable team are doing on the
stable series. To me the above message is a little bit cryptic however
-- which bugs have been fixed, and what was their impact ? I know it
takes time to write down such information, sometimes called release
notes. But I think including this information with the announcements
of the stable releases would be a great service to the people reading
these announcements.

Bart.
