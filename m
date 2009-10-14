Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZJNAdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZJNAdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZJNAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:33:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:34261 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZJNAdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:33:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KTKzGLtcbQ51liu0vwsUEO9pQ9lwRwAZFGczf1kz0/Z0L0x1I2BOPBeQNi32HFRjTw
         BXn9beabDQV9g/OiVJQzdjNJrZUxl/sXl/zbBC+kd1ubeMDbt6HibPgKIDHP0T99Aibm
         2ob+pIrEHIpN/bR+/MO2oeWeMbp+HsjahM/0I=
Message-ID: <4AD51BF9.2050504@gmail.com>
Date: Tue, 13 Oct 2009 18:31:53 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.3: coretemp module fails on i7 870 CPU
References: <alpine.DEB.2.00.0910131952170.29143@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0910131952170.29143@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 05:53 PM, Justin Piszcz wrote:
> Hello,
>
> # uname -r
> 2.6.31.3
>
> # modprobe coretemp
> FATAL: Error inserting coretemp
> (/lib/modules/2.6.31.3/kernel/drivers/hwmon/coretemp.ko): No such device
> Oct 13 19:52:08 p34 kernel: [ 9201.229084] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.254903] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.268091] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.281192] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.294058] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.306917] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.319488] coretemp: Unknown CPU model 1e
> Oct 13 19:52:08 p34 kernel: [ 9201.332122] coretemp: Unknown CPU model 1e
>
> Is there a patch in the latest -rcX for support for support for this model
> CPU?

Yes.
