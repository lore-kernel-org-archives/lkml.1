Return-Path: <linux-kernel-owner+w=401wt.eu-S933752AbYDQQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbYDQQ3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763052AbYDQQ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:29:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYDQQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:28:59 -0400
Message-ID: <4807753F.3000109@zytor.com>
Date: Thu, 17 Apr 2008 12:05:19 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Propagate error code from devpts_pty_new
References: <20080416221524.GA7112@us.ibm.com> <20080417153748.GB14215@sergelap.austin.ibm.com>
In-Reply-To: <20080417153748.GB14215@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting sukadev@us.ibm.com (sukadev@us.ibm.com):
>> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
>> Subject: [PATCH]: Propagate error code from devpts_pty_new
>>
>> Have ptmx_open() propagate any error code returned by devpts_pty_new()
>> (which returns either 0 or -ENOMEM anyway).
>>
>> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> 
> Seems nice and non-contentuous.
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>
